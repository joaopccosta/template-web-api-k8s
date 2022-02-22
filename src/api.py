import argparse

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

def parse_arguments():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--host", help="Host", default="0.0.0.0"
    )
    parser.add_argument(
        "--port",
        help="Port",
        default=8080,
    )

    args = parser.parse_args()
    return args


if __name__ == '__main__':
    args = parse_arguments()
    app.run(host=args.host, port=args.port)

