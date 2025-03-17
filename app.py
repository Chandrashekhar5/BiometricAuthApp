from flask import Flask, request, jsonify
from datetime import datetime

app = Flask(__name__)

trusted_devices = {
    "C7D00FD9-2E9B-49E5-B840-AB83B2B1DB56": {
        "user_id": "chandra@gmail.com",
        "last_authenticated": datetime.now().timestamp()
    }
}

@app.route('/authenticate', methods=['POST'])
def authenticate():
    data = request.json
    
    if not data:
        return jsonify({"success": False, "message": "No data received."}), 400
    
    email = data.get('email')
    token = data.get('token')
    
    if not email or not token:
        return jsonify({"success": False, "message": "Email and token are required."}), 400
    
    try:
        user_id, device_id, expiration_timestamp = token.split('|')
        expiration_timestamp = float(expiration_timestamp)
    except ValueError:
        return jsonify({"success": False, "message": "Invalid token format."}), 400
    
    if datetime.now().timestamp() > expiration_timestamp:
        return jsonify({"success": False, "message": "Token has expired."}), 401
    
    if device_id not in trusted_devices:
        return jsonify({"success": False, "message": "Device is not trusted."}), 403
    
    if trusted_devices[device_id]["user_id"] != email:
        return jsonify({"success": False, "message": "Email does not match the trusted device."}), 403
    
    trusted_devices[device_id]["last_authenticated"] = datetime.now().timestamp()
    
    # Log the response before sending it
    response = {"success": True, "message": "Authentication successful."}
    print("Sending response:", response)
    return jsonify(response), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)