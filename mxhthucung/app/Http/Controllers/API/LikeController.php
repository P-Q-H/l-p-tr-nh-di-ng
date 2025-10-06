<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Post;

class LikeController extends Controller
{
    public function toggle($postId)
    {
        $user = auth()->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthenticated'], 401);
        }

        $post = Post::findOrFail($postId);

        if ($post->likes()->where('user_id', $user->id)->exists()) {
            $post->likes()->detach($user->id);
            return response()->json(['liked' => false]);
        } else {
            $post->likes()->attach($user->id);
            return response()->json(['liked' => true]);
        }
    }

    public function status($postId)
    {
        $user = auth()->user();
        $post = Post::findOrFail($postId);

        $liked = $post->likes()->where('user_id', $user->id)->exists();
        $count = $post->likes()->count();

        return response()->json([
            'liked' => $liked,
            'count' => $count,
        ]);
    }

    // ✅ API mới: Lấy tất cả bài viết đã like
    public function getLikedPosts(Request $request)
    {
        $user = auth()->user();
        
        if (!$user) {
            return response()->json(['error' => 'Unauthenticated'], 401);
        }

        // Lấy các bài viết mà user đã like, kèm thông tin đầy đủ
        $likedPosts = $user->likedPosts()
            ->with('user:id,name,pet_name') // Load thông tin người đăng
            ->withCount('likes') // Đếm số lượt like
            ->orderBy('likes.created_at', 'desc') // Sắp xếp theo thời gian like mới nhất
            ->get()
            ->map(function($post) {
                return [
                    'id' => $post->id,
                    'content' => $post->description ?? '', // ✅ Dùng description thay vì content
                    'image_url' => $post->image ? url('storage/' . $post->image) : null, // ✅ Thêm full URL
                    'pet_type' => $post->pet_type,
                    'pet_name' => $post->pet_name,
                    'breed' => $post->breed,
                    'likes_count' => $post->likes_count,
                    'created_at' => $post->created_at,
                    'user' => [
                        'id' => $post->user->id ?? null,
                        'name' => $post->user->name ?? 'Unknown',
                        'pet_name' => $post->user->pet_name ?? '',
                    ]
                ];
            });

        return response()->json([
            'posts' => $likedPosts,
            'total' => $likedPosts->count()
        ]);
    }
}