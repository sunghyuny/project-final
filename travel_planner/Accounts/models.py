# models.py
from django.contrib.auth.models import AbstractUser, Group, Permission
from django.db import models

from django.contrib.auth.models import AbstractUser
from django.db import models

class CustomUser(AbstractUser):
    age = models.IntegerField(null=True, blank=True)
    email = models.EmailField(unique=True)
    mbti = models.CharField(max_length=4)
    gender_choices = [
        ('male', '남자'),
        ('female', '여자')
    ]
    gender = models.CharField(max_length=10, choices=gender_choices)
    groups = models.ManyToManyField(Group, related_name='customuser_groups')
    user_permissions = models.ManyToManyField(Permission, related_name='customuser_user_permissions')
