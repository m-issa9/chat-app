from django.db import models
from django.contrib.auth.models import User

class Message(models.Model):
    sender = models.ForeignKey(User, on_delete=models.CASCADE, related_name='sent')
    recipient = models.ForeignKey(User, on_delete=models.CASCADE, related_name='received')
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)
