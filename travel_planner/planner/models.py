from django.db import models

# Create your models here.
class TravelPlan(models.Model):
    date = models.DateField()
    destination = models.CharField(max_length=20)
    participants = models.PositiveIntegerField()
    accommodation = models.CharField(max_length=20)
    attractions = models.CharField(max_length=20)
    restaurants = models.CharField(max_length=20)
    experience = models.CharField(max_length=20)
    exhibition = models.CharField(max_length=20)

    def __str__(self):
        return f"{self.date} - {self.destination}"

class activity_category(models.Model):
    name= models.TextField()

class activity(models.Model):
    name = models.TextField()
    price = models.TextField()
    photo = models.ImageField(upload_to='activity_photo/')
    location = models.TextField()
    telephone = models.TextField()
    time = models.TextField()
    category = models.ForeignKey(activity_category, on_delete=models.CASCADE)