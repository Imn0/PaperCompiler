import requests
import json

url = "http://127.0.0.1:5000/test"
img_path = "../test_raw.png"

with open(img_path, 'rb') as f:
    files = {"image": f}
    
    response = requests.get(url, files=files)



# print(json.dumps(response.json(), indent=4))

aa = response.json().get('reply').get('out')
code = response.json().get('reply').get('ocr')

print(f'{code}')
print(f'{aa}')