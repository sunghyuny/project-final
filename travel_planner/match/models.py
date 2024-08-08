from django.db import models
from django.db.models.signals import post_save, m2m_changed
from django.dispatch import receiver

from Accounts.models import CustomUser

class ChatRoom(models.Model):
    STATUS_CHOICES = [
        ('recruiting', '모집 중'),
        ('completed', '모집 완료')
    ]
    name = models.CharField(max_length=255)
    capacity = models.IntegerField()
    location = models.CharField(max_length=255, null=True, blank=True)
    date = models.DateField(null=True, blank=True)
    departure_date = models.DateField(null=True, blank=True)  # 출발 날짜 필드 추가
    arrival_date = models.DateField(null=True, blank=True)    # 도착 날짜 필드 추가
    description = models.TextField(null=True, blank=True)
    image = models.ImageField(upload_to='chat_room_images/', null=True, blank=True)
    participants = models.ManyToManyField(CustomUser, related_name='chat_rooms')  # CustomUser 대신 CustomUser 사용
    creator = models.ForeignKey(CustomUser, related_name='created_chat_rooms', on_delete=models.CASCADE)  # CustomUser 대신 CustomUser 사용
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='recruiting')
    def __str__(self):
        return self.name
    @property
    def current_participants(self):
        return self.participants.count()

    @property
    def max_participants(self):
        return self.capacity

    @property
    def is_full(self):
        return self.current_participants >= self.max_participants


@receiver(m2m_changed, sender=ChatRoom.participants.through)
def update_room_status(sender, instance, action, **kwargs):
    if action == 'post_add' or action == 'post_remove':
        if instance.is_full and instance.status == 'recruiting':
            instance.status = 'completed'
            instance.save()
        elif not instance.is_full and instance.status == 'completed':
            instance.status = 'recruiting'
            instance.save()

class Message(models.Model):
    chat_room = models.ForeignKey(ChatRoom, on_delete=models.CASCADE, related_name='messages')
    sender = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    content = models.TextField()
    timestamp = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.sender.username}: {self.content[:20]}'
