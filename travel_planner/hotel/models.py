from django.db import models
from django.conf import settings
from thesights.models import RegionCategory

class Accommodation(models.Model):
    name = models.CharField(max_length=100)
    photo = models.ImageField(upload_to='accommodations_photos/')
    price = models.TextField()
    details = models.TextField()
    amenities = models.TextField()
    quantity = models.IntegerField()
    likes = models.PositiveIntegerField(default=0)
    region_category = models.ForeignKey(RegionCategory, on_delete=models.CASCADE)

    def __str__(self):
        return self.name

class HotelReservation(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='hotel_reservations', null=True, blank=True)
    accommodation = models.ForeignKey(Accommodation, on_delete=models.CASCADE)
    check_in = models.DateField()
    check_out = models.DateField()
    guests = models.IntegerField()

    def __str__(self):
        return f"{self.user.username} - {self.accommodation.name} ({self.check_in} to {self.check_out})"