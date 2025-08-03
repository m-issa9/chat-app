from django.urls import path
from ..views.views import message_list

urlpatterns = [
    path('messages/<str:user1>/<str:user2>/', message_list),
]
