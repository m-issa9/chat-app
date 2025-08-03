from django.contrib.auth.models import User
from rest_framework.decorators import api_view
from rest_framework.response import Response
from ..models.models import Message

@api_view(['GET'])
def message_list(request, user1, user2):
    u1 = User.objects.get(username=user1)
    u2 = User.objects.get(username=user2)
    msgs = Message.objects.filter(sender__in=[u1, u2], recipient__in=[u1, u2]).order_by('timestamp')
    data = [{"sender": m.sender.username, "recipient": m.recipient.username, "message": m.content} for m in msgs]
    return Response(data)
