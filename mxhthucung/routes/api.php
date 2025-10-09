<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\PostController;
use App\Http\Controllers\API\SettingsController;
use App\Http\Controllers\API\LikeController;
use App\Http\Controllers\API\CommentController;
use App\Http\Controllers\API\FollowController;

// 🔐 Xác thực tài khoản
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:api')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);
    Route::put('/me', [AuthController::class, 'update']);
    Route::delete('/me', [AuthController::class, 'destroy']);
    Route::get('/user', fn(Request $request) => response()->json($request->user()));
    Route::get('/users', [UserController::class, 'index']);

    // 🌐 Ngôn ngữ & hồ sơ
    Route::post('/language', [UserController::class, 'updateLanguage']);
    Route::get('/users/{id}', [UserController::class, 'show']);
    Route::put('/users/{id}', [UserController::class, 'update']);
    Route::post('/users/{id}/avatar', [UserController::class, 'uploadAvatar']);
    Route::post('/users/change-password', [UserController::class, 'changePassword']);

    // ⚙️ Cài đặt người dùng
    Route::get('/settings', [SettingsController::class, 'getSettings']);
    Route::post('/settings/update', [SettingsController::class, 'update']);

    // 🐾 Hồ sơ thú cưng
    Route::get('/pet-profile', [PostController::class, 'getUserPosts']);
    Route::put('/pet-profile/{id}', [PostController::class, 'updatePost']);
    Route::delete('/pet-profile/{id}', [PostController::class, 'deletePost']);

    // 📝 Đăng bài viết
    Route::post('/posts', [PostController::class, 'store']);
    Route::delete('/posts/{id}', [PostController::class, 'destroy']);

    // ❤️ Like bài viết
    Route::post('/posts/{postId}/like', [LikeController::class, 'toggle']);
    Route::get('/posts/{postId}/likes', [LikeController::class, 'status']);
    Route::get('/posts/liked', [LikeController::class, 'getLikedPosts']);

    // 💬 Bình luận
    Route::get('/posts/{postId}/comments', [CommentController::class, 'index']);
    Route::post('/posts/{postId}/comments', [CommentController::class, 'store']);
    Route::delete('/comments/{commentId}', [CommentController::class, 'destroy']);

    // 👥 Follow/Unfollow
    Route::post('/users/{userId}/follow', [FollowController::class, 'toggle']);
    Route::get('/users/{userId}/follow-status', [FollowController::class, 'checkStatus']);
    Route::get('/users/{userId}/follow-stats', [FollowController::class, 'getStats']);
    Route::get('/users/{userId}/followers', [FollowController::class, 'getFollowers']);
    Route::get('/users/{userId}/following', [FollowController::class, 'getFollowing']);
});

// 📱 Public routes
Route::get('/posts/type/{petType}', [PostController::class, 'filterByType']);
Route::get('/posts/user/{id}/{petType}', [PostController::class, 'getByUserAndType']);
Route::get('/posts', [PostController::class, 'index']);