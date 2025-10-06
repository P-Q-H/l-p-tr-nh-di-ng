<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Comment;
use App\Models\Post;

class CommentController extends Controller
{
    // Lấy tất cả bình luận của một bài viết
    public function index($postId)
    {
        $post = Post::findOrFail($postId);
        
        $comments = $post->comments()
            ->with('user:id,name,pet_name')
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function($comment) {
                return [
                    'id' => $comment->id,
                    'content' => $comment->content,
                    'created_at' => $comment->created_at,
                    'user' => [
                        'id' => $comment->user->id,
                        'name' => $comment->user->name,
                        'pet_name' => $comment->user->pet_name ?? '',
                    ]
                ];
            });

        return response()->json([
            'comments' => $comments,
            'total' => $comments->count()
        ]);
    }

    // Thêm bình luận mới
    public function store(Request $request, $postId)
    {
        $request->validate([
            'content' => 'required|string|max:1000',
        ]);

        $user = auth()->user();
        $post = Post::findOrFail($postId);

        $comment = Comment::create([
            'user_id' => $user->id,
            'post_id' => $post->id,
            'content' => $request->content,
        ]);

        $comment->load('user:id,name,pet_name');

        return response()->json([
            'message' => 'Bình luận thành công',
            'comment' => [
                'id' => $comment->id,
                'content' => $comment->content,
                'created_at' => $comment->created_at,
                'user' => [
                    'id' => $comment->user->id,
                    'name' => $comment->user->name,
                    'pet_name' => $comment->user->pet_name ?? '',
                ]
            ]
        ], 201);
    }

    // Xóa bình luận
    public function destroy($commentId)
    {
        $user = auth()->user();
        $comment = Comment::findOrFail($commentId);

        // Chỉ cho phép xóa bình luận của chính mình
        if ($comment->user_id !== $user->id) {
            return response()->json(['error' => 'Unauthorized'], 403);
        }

        $comment->delete();

        return response()->json(['message' => 'Đã xóa bình luận']);
    }
}