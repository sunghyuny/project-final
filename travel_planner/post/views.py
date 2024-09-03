from django.shortcuts import render, get_object_or_404, redirect
from django.utils import timezone
from .models import Post, Comment

def post_list(request):
    posts = Post.objects.all().order_by('-created_at')
    return render(request, 'Community/main.html', {'posts': posts})

def post_detail(request, pk):
    post = get_object_or_404(Post, pk=pk)
    return render(request, 'community/post_detail.html', {'post': post})

def post_new(request):
    if request.method == "POST":
        title = request.POST.get('title')
        content = request.POST.get('content')
        location = request.POST.get('location')
        category = request.POST.get('category')
        start_date = request.POST.get('start_date')
        end_date = request.POST.get('end_date')
        image = request.FILES.get('image')  # 이미지 파일 가져오기

        post = Post(
            title=title,
            content=content,
            author=request.user,
            created_at=timezone.now(),
            location=location,
            category=category,
            start_date=start_date,
            end_date=end_date,
            image=image  # 이미지 필드에 업로드한 이미지 할당
        )
        post.save()
        return redirect('post_detail', pk=post.pk)
    return render(request, 'Community/create.html')

def add_comment_to_post(request, pk):
    post = get_object_or_404(Post, pk=pk)
    if request.method == "POST":
        content = request.POST.get('content')
        comment = Comment(post=post, author=request.user, content=content, created_at=timezone.now())
        comment.save()
        return redirect('post_detail', pk=post.pk)
    return render(request, 'Community/create.html', {'post': post})
def post_detail(request, pk):
    post = get_object_or_404(Post, pk=pk)
    return render(request, 'Community/detail.html', {'post': post})