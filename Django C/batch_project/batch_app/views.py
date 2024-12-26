from django.shortcuts import render

# Create your views here.
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

        # Save data to the database
        BatchData.objects.create(param1=param1, param2=param2, timer=timer, state=state)
        return JsonResponse({'status': 'success'})

def get_random_values(request):
    import random
    param1 = random.randint(0, 100)
    param2 = random.randint(0, 4)
    return JsonResponse({'param1': param1, 'param2': param2})





