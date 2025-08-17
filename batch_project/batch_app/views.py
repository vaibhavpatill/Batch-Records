from django.shortcuts import render
from .forms import BatchForm
from django.http import JsonResponse
import random

def batch_view(request):
    if request.method == 'POST':
        form = BatchForm(request.POST)
        if form.is_valid():
            # Process form data here
            batch_name = form.cleaned_data['batch_name']
            batch_id = form.cleaned_data['batch_id']
            login_name = form.cleaned_data['login_name']
            return render(request, 'batch_app/batch.html', {'form': form})
    else:
        form = BatchForm()

    return render(request, 'batch_app/batch.html', {'form': form})

from django.http import JsonResponse
from .models import BatchData

def store_data(request):
    if request.method == 'POST':
        param1 = request.POST.get('param1')
        param2 = request.POST.get('param2')
        timer = request.POST.get('timer').split()[0]  # Extract the timer value (in seconds)
        state = request.POST.get('state')
        batch_name = request.POST.get('batch_name', 'Unknown')
        batch_id = request.POST.get('batch_id', 'Unknown')
        login_name = request.POST.get('login_name', 'Unknown')

        # Save data to the database
        BatchData.objects.create(
            batch_name=batch_name,
            batch_id=batch_id,
            login_name=login_name,
            param1=param1, 
            param2=param2, 
            timer=timer, 
            state=state
        )
        return JsonResponse({'status': 'success'})

def get_random_values(request):
    import random
    param1 = random.randint(0, 100)
    param2 = round(random.uniform(0.00, 4.00), 2)
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
                from django.http import HttpResponse
                import csv
                from io import StringIO
                
                from django.conf import settings
                
                # SSRS Report URL - works with MSSQL backend
                ssrs_url = getattr(settings, 'SSRS_URL', 'http://localhost/ReportServer')
                report_path = getattr(settings, 'SSRS_REPORT_PATH', '/BatchReports/BatchProcessReport')
                
                # Generate report URL
                report_url = f"{ssrs_url}?{report_path}&BatchID={batch_id}&rs:Format=PDF"
                
                return JsonResponse({
                    'status': 'success',
                    'message': 'Report generated successfully',
                    'report_url': report_url
                })
                
            except Exception as e:
                return JsonResponse({'status': 'error', 'message': str(e)})
        else:
            return JsonResponse({'status': 'error', 'message': 'Batch ID is required'})
    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})





