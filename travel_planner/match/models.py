from django.db import models
from Accounts.models import CustomUser

class ChatRoom(models.Model):
    name = models.CharField(max_length=255)
    capacity = models.IntegerField()
    location = models.CharField(max_length=255, null=True, blank=True)
    date = models.DateField(null=True, blank=True)
    description = models.TextField(null=True, blank=True)
    image = models.ImageField(upload_to='chat_room_images/', null=True, blank=True)
    participants = models.ManyToManyField(CustomUser, related_name='chat_rooms')
    creator = models.ForeignKey(CustomUser, related_name='created_chat_rooms', on_delete=models.CASCADE)

    def __str__(self):
        return self.name

class Message(models.Model):
    chat_room = models.ForeignKey(ChatRoom, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.sender.username}: {self.content[:20]}'
