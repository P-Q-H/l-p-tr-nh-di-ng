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
            \Log::error('Không xác thực được người dùng');
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
}
