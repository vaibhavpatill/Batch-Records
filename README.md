# Batch Records

A Django web application for managing batch data records with form-based data entry and display functionality.

## Features

- Add new batch records through web forms
- View and manage batch data
- Clean, responsive web interface
- Django admin integration

## Project Structure

```
batch_project/
├── batch_app/              # Main application
│   ├── migrations/         # Database migrations
│   ├── templates/          # HTML templates
│   ├── models.py          # Data models
│   ├── views.py           # View logic
│   ├── forms.py           # Form definitions
│   └── urls.py            # URL routing
├── batch_project/         # Project settings
│   ├── settings.py        # Django settings
│   ├── urls.py            # Main URL configuration
│   └── wsgi.py            # WSGI configuration
├── manage.py              # Django management script
└── requirements.txt       # Python dependencies
```

## Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/vaibhavpatill/Batch-Records.git
   cd Batch-Records
   ```

2. **Create virtual environment**
   ```bash
   python -m venv venv
   venv\Scripts\activate  # Windows
   # or
   source venv/bin/activate  # Linux/Mac
   ```

3. **Install dependencies**
   ```bash
   cd batch_project
   pip install -r requirements.txt
   ```

4. **Run migrations**
   ```bash
   python manage.py migrate
   ```

5. **Start development server**
   ```bash
   python manage.py runserver
   ```

6. **Access the application**
   Open your browser and go to `http://127.0.0.1:8000/`

## Usage

- Navigate to the main page to add new batch records
- Fill in the required fields and submit the form
- View submitted records and manage data through the interface

## Technologies Used

- Django 4.x
- Python 3.x
- HTML/CSS
- SQLite (default database)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is open source and available under the MIT License.