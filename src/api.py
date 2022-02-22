from flask import Flask, request
from Handler import Handler

app = Flask(__name__)
handler = Handler()

@app.route('/')
def home():
    return "200"

@app.route('/health')
def health():
    return "200"

@app.route('/api/task', methods=['POST'])
def create_task():
    request_data = request.get_json()
    task = request_data['task']
    return handler.create_task(task)


@app.route('/api/task', methods=['PUT'])
def update_task():
    request_data = request.get_json()
    return handler.update_task(request_data['task'])

if __name__ == '__main__':
    app.run(host="127.0.0.1")

