from django.contrib import admin
from .models import Package, Reservation

# Register your models here.

class PackageAdmin(admin.ModelAdmin):
    list_display = ('destination', 'start_date', 'end_date', 'adult_price', 'youth_price', 'child_price', 'accommodation', 'accommodation_price', 'region_category')
    search_fields = ('destination',)
    list_filter = ('start_date', 'end_date', 'region_category')

class ReservationAdmin(admin.ModelAdmin):
    list_display = ('user', 'package', 'adult_count', 'youth_count', 'child_count', 'total_price', 'created_at')
    search_fields = ('user__username', 'package__destination')
    list_filter = ('created_at',)

admin.site.register(Package, PackageAdmin)
admin.site.register(Reservation, ReservationAdmin)
