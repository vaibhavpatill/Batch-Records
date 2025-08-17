from django import forms
from .models import BatchData

class BatchForm(forms.ModelForm):
    class Meta:
        model = BatchData
        fields = ['batch_name', 'batch_id', 'login_name']
        widgets = {
            'batch_name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Enter batch name (e.g., PCB-2024-001)',
                'required': True
            }),
            'batch_id': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Enter unique batch ID',
                'required': True
            }),
            'login_name': forms.TextInput(attrs={
                'class': 'form-control',
                'placeholder': 'Enter operator name',
                'required': True
            }),
        }
