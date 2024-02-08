# serializers.py

from rest_framework import serializers
from .models import CustomUser
from django.contrib.auth import authenticate
class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ('id', 'username', 'age', 'email', 'mbti', 'gender', 'password')
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = CustomUser(
            username=validated_data['username'],
            age=validated_data['age'],
            email=validated_data['email'],
            mbti=validated_data['mbti'],
            gender=validated_data['gender']
        )
        user.set_password(validated_data['password'])
        user.save()
        return user

class UserSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=150)
    password = serializers.CharField(max_length=128, write_only=True)

    def validate(self, data):
        user = authenticate(**data)
        if user and user.is_active:
            return user
        raise serializers.ValidationError("Incorrect Credentials")
