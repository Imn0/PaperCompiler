from paperc.run_code import run_code
import cv2
import numpy as np

from flask import Flask, jsonify, request
import pytesseract

from unidecode import unidecode

app = Flask(__name__)

@app.route('/test', methods=['GET'])
def get_test():
    # Get the 'name' parameter from the query string

    img = request.files.get('image', None)

    image = cv2.imdecode(np.fromstring(img.read(), np.uint8), cv2.IMREAD_UNCHANGED)

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(gray, (3,3), 0)
    thresh = cv2.threshold(blur, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]

    # Morph open to remove noise and invert image
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3,3))
    opening = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel, iterations=1)
    invert = 255 - opening

    recognized_text = pytesseract.image_to_string(invert)
    # Print the final string
    result_ascii = unidecode(recognized_text)

    out = run_code(f'{result_ascii}', 54)
    test = {
        "ocr": result_ascii,
        "out": out
    }

    return jsonify({'reply': test})

@app.route('/compile', methods=['POST'])
def get_compile():

    code= request.json.get('code')
    if code is None:
        return jsonify({'error': 'No code provided'})
    print(code)

    # code = unidecode(code)
    code = code.encode('utf-8', 'ignore')
    out = run_code(f'{code}', 54)
    test = {
        "out": out  
    }

    return jsonify({'reply': test})



@app.route('/ocr', methods=['GET'])
def get_ocr():
     # Get the 'name' parameter from the query string

    img = request.files.get('image', None)

    image = cv2.imdecode(np.fromstring(img.read(), np.uint8), cv2.IMREAD_UNCHANGED)

    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(gray, (3,3), 0)
    thresh = cv2.threshold(blur, 0, 255, cv2.THRESH_BINARY_INV + cv2.THRESH_OTSU)[1]

    # Morph open to remove noise and invert image
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3,3))
    opening = cv2.morphologyEx(thresh, cv2.MORPH_OPEN, kernel, iterations=1)
    invert = 255 - opening

    recognized_text = pytesseract.image_to_string(invert)
    # Print the final string
    result_ascii = unidecode(recognized_text)

    test = {
        "ocr": result_ascii,
    }

    return jsonify({'reply': test})




@app.route('/test_empty', methods=['POST'])
def get_test_empty():

    data = request.json  # Assuming the data is sent as JSON

    # Process the data (for demonstration, just echoing back)
    processed_data = {'received_data': data}

    print(data)

    test = {
        "name": "aa",
        "ocr": "dummy ocr",
        "out": "dummy output"
    }

    return jsonify({'reply': test})

if __name__ == '__main__':
    app.run(debug=True, port=5000, host='0.0.0.0')
