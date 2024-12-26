from django import forms
from .models import BatchData

class BatchForm(forms.ModelForm):
    class Meta:
        model = BatchData
        fields = ['batch_name', 'batch_id', 'login_name']
