FROM python:latest 

WORKDIR /app

# Install dependencies
COPY requirements.txt .

RUN pip install -r requirements.txt

# Copy the application code
COPY . .

# Expose the application port
EXPOSE 5000
#set entrypoint for the container
CMD ["python", "-m", "flask", "run", "--host", "0.0.0.0"]
