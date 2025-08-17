from django.db import models

# Create your models here.
class BatchData(models.Model):
    batch_name = models.CharField(max_length=100)
    batch_id = models.CharField(max_length=100)
    login_name = models.CharField(max_length=100)
    param1 = models.IntegerField()
    param2 = models.DecimalField(max_digits=4, decimal_places=2)
    timer = models.IntegerField()
    state = models.CharField(max_length=50)
    timestamp = models.DateTimeField(auto_now_add=True)