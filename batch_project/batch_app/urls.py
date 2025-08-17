from django.urls import path
from . import views

urlpatterns = [
    path('', views.batch_view, name='batch_view'),
    path('store_data/', views.store_data, name='store_data'),
    path('get_random_values/', views.get_random_values, name='get_random_values'),
    path('get_batch_data/', views.get_batch_data, name='get_batch_data'),
    path('generate_ssrs_report/', views.generate_ssrs_report, name='generate_ssrs_report'),
]
