from django.shortcuts import render
from .forms import BatchForm
from django.http import JsonResponse
import random
import pyodbc
from django.conf import settings

def batch_view(request):
    if request.method == 'POST':
        form = BatchForm(request.POST)
        if form.is_valid():
            batch_name = form.cleaned_data['batch_name']
            batch_id = form.cleaned_data['batch_id']
            login_name = form.cleaned_data['login_name']
            return render(request, 'batch_app/batch.html', {'form': form})
    else:
        form = BatchForm()
    return render(request, 'batch_app/batch.html', {'form': form})

from .models import BatchData

def store_data(request):
    if request.method == 'POST':
        param1 = request.POST.get('param1')
        param2 = request.POST.get('param2')
        timer = request.POST.get('timer').split()[0]
        state = request.POST.get('state')
        batch_name = request.POST.get('batch_name', 'Unknown')
        batch_id = request.POST.get('batch_id', 'Unknown')
        login_name = request.POST.get('login_name', 'Unknown')

        # Save to SQLite (Django)
        BatchData.objects.create(
            batch_name=batch_name,
            batch_id=batch_id,
            login_name=login_name,
            param1=param1, 
            param2=param2, 
            timer=timer, 
            state=state
        )
        
        # Also save to SQL Server for SSRS
        try:
            conn = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=localhost\\SQLEXPRESS;DATABASE=BatchDB;Trusted_Connection=yes;')
            cursor = conn.cursor()
            cursor.execute("""
                INSERT INTO batch_data (batch_number, product_name, temperature, pressure, flow_rate, ph_level, timer_value, state)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            """, (batch_id, batch_name, float(param1), float(param2), 15.2, 7.1, int(timer), state))
            conn.commit()
            conn.close()
        except Exception as e:
            print(f"SQL Server insert error: {e}")
        
        return JsonResponse({'status': 'success'})

def get_random_values(request):
    param1 = random.randint(50, 100)
    param2 = round(random.uniform(1.50, 4.00), 2)
    return JsonResponse({'param1': param1, 'param2': param2})

def get_batch_data(request):
    if request.method == 'GET':
        batch_id = request.GET.get('batch_id')
        if batch_id:
            data = BatchData.objects.filter(batch_id=batch_id).order_by('timer')
            batch_data = []
            for record in data:
                batch_data.append({
                    'timer': record.timer,
                    'param1': record.param1,
                    'param2': record.param2,
                    'state': record.state,
                    'timestamp': record.timestamp.strftime('%H:%M:%S')
                })
            return JsonResponse({'data': batch_data})
    return JsonResponse({'data': []})

def generate_ssrs_report(request):
    if request.method == 'POST':
        batch_id = request.POST.get('batch_id')
        if batch_id:
            try:
                import requests
                from requests.auth import HTTPBasicAuth
                from django.conf import settings
                import urllib.parse
                
                # Check if batch data exists
                data = BatchData.objects.filter(batch_id=batch_id)
                if not data.exists():
                    return JsonResponse({'status': 'error', 'message': 'No data found for this batch ID'})
                
                # SSRS Report configuration
                ssrs_url = getattr(settings, 'SSRS_URL', 'http://localhost/ReportServer')
                report_path = getattr(settings, 'SSRS_REPORT_PATH', '/BatchReports/BatchProcessReport_2022')
                
                # Build SSRS report URL for direct report execution
                report_url = f"http://localhost:8080/ReportServer/Pages/ReportViewer.aspx?/BatchReports/BatchProcessReport_2022&BatchNumber={batch_id}"
                
                # Return URL for client-side redirect (browser will handle authentication)
                return JsonResponse({
                    'status': 'success',
                    'message': 'Opening SSRS report...',
                    'report_url': report_url
                })
                
            except Exception as e:
                return JsonResponse({'status': 'error', 'message': f'Error generating report: {str(e)}'})
        else:
            return JsonResponse({'status': 'error', 'message': 'Batch ID is required'})
    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})





