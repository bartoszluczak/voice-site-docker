FROM python:3.10.6-slim
ENV PYTHONUNBUFFERED 1

WORKDIR /usr/src/app

# get portaudio and ffmpeg
RUN apt-get update \
        && apt-get install libportaudio2 libportaudiocpp0 portaudio19-dev libasound-dev libsndfile1-dev -y
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install -y ffmpeg

WORKDIR /code
COPY ./requirements.txt /code/requirements.txt
RUN pip install --no-cache-dir --upgrade -r requirements.txt
COPY main.py /code/main.py
COPY speller_agent.py /code/speller_agent.py

CMD exec ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "3000"]
##CMD exec uvicorn "main:app" --host :$PORT port

# Run the web service on container startup.
# Use gunicorn webserver with one worker process and 8 threads.
# For environments with multiple CPU cores, increase the number of workers
# to be equal to the cores available.
# Timeout is set to 0 to disable the timeouts of the workers to allow Cloud Run to handle instance scaling.
##CMD exec gunicorn --bind :$PORT --workers 1 --threads 8 --timeout 0 app:app
