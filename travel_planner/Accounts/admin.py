from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser
# Register your models here.
class CustomUserAdmin(UserAdmin):
    # 커스텀 유저 모델의 필드들을 표시하고 원하는대로 수정할 수 있습니다.
    list_display = ('username', 'email', 'age', 'is_staff', 'is_active',)
    search_fields = ('username', 'email', 'is_staff')
    readonly_fields = ('date_joined', 'last_login',)

    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()

admin.site.register(CustomUser, CustomUserAdmin)