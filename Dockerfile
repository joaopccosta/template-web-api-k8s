FROM python:3.10-slim AS build

RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY . .
RUN pip install --no-cache-dir -r requirements.txt
RUN python setup.py install

FROM python:3.10-slim AS production
COPY --from=build /opt/venv /opt/venv
COPY . app

ENV PATH="/opt/venv/bin:$PATH"

EXPOSE 8080
CMD ["python3", "app/src/api.py"]