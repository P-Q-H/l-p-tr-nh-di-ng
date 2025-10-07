<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\PostController;
use App\Http\Controllers\API\PetController;
use App\Http\Controllers\API\SettingsController;
use App\Http\Controllers\API\LikeController;
use App\Http\Controllers\API\CommentController;  



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
    Route::post('/edit-profile', [UserController::class, 'editProfile']);
    Route::post('/change-password', [UserController::class, 'changePassword']);
    

    // ⚙️ Cài đặt người dùng
    Route::get('/settings', [SettingsController::class, 'getSettings']);
    Route::post('/settings/update', [SettingsController::class, 'updateSettings']);
    Route::middleware('auth:api')->post('/settings/update', [SettingsController::class, 'update']);
    // Route::get('/api/users/{id}', [UserController::class, 'show']);
    Route::get('/users/{id}', [UserController::class, 'show']);


    // 🐾 Hồ sơ thú cưng của người dùng
    Route::get('/pet-profile', [PostController::class, 'getUserPosts']);
    Route::put('/pet-profile/{id}', [PostController::class, 'updatePost']);
    Route::delete('/pet-profile/{id}', [PostController::class, 'deletePost']);

   
});
// đăng bài viết
Route::middleware('auth:api')->post('/posts', [PostController::class, 'store']);
Route::get('/posts/type/{petType}', [PostController::class, 'filterByType']);
Route::get('/posts/user/{id}/{petType}', [PostController::class, 'getByUserAndType']);
Route::get('/posts', [PostController::class, 'index']);

// xóa bài viết 
Route::middleware('auth:api')->delete('/posts/{id}', [PostController::class, 'destroy']);



//like bài viết
Route::middleware('auth:api')->group(function () {
    Route::post('/posts/{postId}/like', [LikeController::class, 'toggle']);
    Route::get('/posts/{postId}/likes', [LikeController::class, 'status']);
});
// danh sách bài viết đã thích của người dùng
Route::middleware('auth:api')->get('/user/liked-posts', [LikeController::class, 'likedPosts']);
// lấy tất cả bài viết đã like
Route::middleware('auth:api')->group(function () {
  // Trong Route::middleware('auth:api')->group(function () {
Route::post('/posts/{postId}/like', [LikeController::class, 'toggle']);
Route::get('/posts/{postId}/likes', [LikeController::class, 'status']);
Route::get('/posts/liked', [LikeController::class, 'getLikedPosts']); // ✅ Route mới
});

Route::middleware('auth:api')->group(function () {
   // Thêm vào Route::middleware('auth:api')->group
  Route::get('/posts/{postId}/comments', [CommentController::class, 'index']);
  Route::post('/posts/{postId}/comments', [CommentController::class, 'store']);
  Route::delete('/comments/{commentId}', [CommentController::class, 'destroy']);
});





