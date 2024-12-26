from django.urls import path
from . import views

urlpatterns = [
    path('', views.batch_view, name='batch_view'),
    path('store_data/', views.store_data, name='store_data'),  # Ensure this path exists
    path('get_random_values/', views.get_random_values, name='get_random_values'),
]
