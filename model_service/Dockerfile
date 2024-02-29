FROM python:3.10

WORKDIR /usr/src/app

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

# Create an empty inputs directory
RUN mkdir -p ./inputs

COPY . .

EXPOSE 5000

# Define environment variable
ENV FLASK_ENV=production

# Run the application
CMD ["flask", "run", "--host=0.0.0.0"]