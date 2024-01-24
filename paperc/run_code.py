import requests
import time


def run_code(code, language_id):

    
    # Judge0 local API endpoint for submitting code
    endpoint = "http://127.0.0.1:2358/submissions"

    data = {
        "source_code": code,
        "language_id": language_id,
        "stdin": ""
    }

    # Send a POST request to Judge0 API
    response = requests.post(endpoint, json=data)

    # Check if the request was successful (HTTP status code 201)
    if response.status_code == 201:
        submission_token = response.json()["token"]

        # Poll for the submission status
        while True:
            result_endpoint = f"{endpoint}/{submission_token}"
            result_response = requests.get(result_endpoint)
            print(result_response.json())
            if result_response.status_code == 200:
                result_data = result_response.json()
                status = result_data["status"]["id"]

                if status == 3:  
                    output = result_data["stdout"]
                    return output
                elif status == 6:  
                    print("Submission error:",
                          result_data["status"]["description"])
                    return None

            else:
                print("Error retrieving result:", result_response.text)
                return None
            time.sleep(0.5)
    else:
        print("Error submitting code:", response.text)
        return None

