<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Post;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Auth;

class PostController extends Controller
{
    // Đăng bài viết mới
public function store(Request $request)
{
    Log::info('Đăng bài:', $request->all());
    Log::info('Người dùng:', ['id' => optional(auth()->user())->id]);
    


    $request->validate([
        'pet_name' => 'required|string|max:255',
        'breed' => 'nullable|string|max:255',
        'description' => 'nullable|string',
        'pet_type' => 'required|string|max:50',
        'image' => 'required|image|max:2048',
    ]);

    $filename = $request->file('image')->store('posts', 'public');
    $user = auth()->user();

    $post = Post::create([
        'user_id' => $user->id,
        'pet_name' => $request->pet_name,
        'breed' => $request->breed,
        'description' => $request->description,
        'image' => $filename,
        'pet_type' => $request->pet_type,
    ]);

    return response()->json(['message' => 'Đăng bài thành công', 'data' => $post], 200);
}

public function filterByType($petType)
{
    $posts = Post::whereRaw('LOWER(pet_type) = ?', [strtolower($petType)])
        ->with('user')
        ->latest()
        ->get();

    return response()->json([
        'status' => 'success',
        'data' => $posts->map(fn($post) => [
            'id' => $post->id,
            'pet_name' => $post->pet_name,
            'breed' => $post->breed,
            'description' => $post->description,
            'image' => $post->image,
            'pet_type' => $post->pet_type,
            'created_at' => $post->created_at,
            'username' => $post->user->name ?? 'Ẩn danh',
            'user_id' => $post->user_id, // ✅ thêm dòng này
        ]),
    ]);
}

public function getByUserAndType($id, $petType)
{
    $posts = Post::where('user_id', $id)
        ->whereRaw('LOWER(pet_type) = ?', [strtolower($petType)])
        ->with('user')
        ->latest()
        ->get();

    return response()->json([
        'status' => 'success',
        'data' => $posts->map(fn($post) => [
            'id' => $post->id,
            'pet_name' => $post->pet_name,
            'breed' => $post->breed,
            'description' => $post->description,
            'image' => $post->image,
            'pet_type' => $post->pet_type,
            'created_at' => $post->created_at,
            'username' => $post->user->name ?? 'Ẩn danh',
            'user_id' => $post->user_id, // ✅ thêm dòng này
        ]),
    ]);
}

public function destroy($id)
{
    $user = auth()->user();
    $post = Post::find($id);

    if (!$post || $post->user_id !== $user->id) {
        return response()->json(['error' => 'Không có quyền xóa bài viết này'], 403);
    }

    Storage::disk('public')->delete($post->image);
    $post->delete();

    return response()->json(['message' => 'Đã xóa bài viết thành công']);
}

public function index()
{
    $posts = Post::with('user')->latest()->get();

    return response()->json([
        'status' => 'success',
        'data' => $posts->map(fn($post) => [
            'id' => $post->id,
            'user_id' => $post->user_id,
            'pet_name' => $post->pet_name,
            'breed' => $post->breed,
            'description' => $post->description,
            'image' => $post->image,
            'pet_type' => $post->pet_type,
            'created_at' => $post->created_at,
            'username' => $post->user->name ?? 'Ẩn danh',
        ]),
    ]);
      $posts = Post::withCount('likes')->get();

    return response()->json($posts);
}


}
