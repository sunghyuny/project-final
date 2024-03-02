from rest_framework import serializers
from django.contrib.auth import authenticate
from .models import CustomUser

from rest_framework import serializers
from .models import CustomUser

class CustomUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'password', 'email', 'age', 'mbti', 'gender']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = CustomUser.objects.create_user(
            username=validated_data['username'],
            password=validated_data['password'],
            email=validated_data['email'],
            age=validated_data.get('age'),
            mbti=validated_data.get('mbti'),
            gender=validated_data.get('gender')
        )
        return user

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ('id', 'username', 'email', 'age', 'mbti', 'gender')


User = CustomUser

class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(style={'input_type': 'password'})

    def validate(self, data):
        email = data.get('email')
        password = data.get('password')

        if email and password:
            user = User.objects.filter(email=email).first()

            if user:
                if user.check_password(password):
                    if user.is_active:
                        data['user'] = user
                        return data
                    else:
                        raise serializers.ValidationError("계정이 비활성화되었습니다.")
                else:
                    raise serializers.ValidationError("이메일 또는 비밀번호가 올바르지 않습니다.")
            else:
                raise serializers.ValidationError("이메일 또는 비밀번호가 올바르지 않습니다.")
        else:
            raise serializers.ValidationError("이메일과 비밀번호를 입력해주세요.")