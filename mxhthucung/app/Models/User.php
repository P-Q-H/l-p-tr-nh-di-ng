<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens,  Notifiable;

// danh sách bài viết đã thích của người dùng hiện tại
public function likedPosts()
{
    return $this->belongsToMany(Post::class, 'likes', 'user_id', 'post_id');
}
// bài viết đã thích của người dùng
public function likes()
{
    return $this->belongsToMany(Post::class, 'likes', 'user_id', 'post_id');
}

 // Người đang theo dõi user này (followers)
public function followers()
    {
        return $this->belongsToMany(User::class, 'follows', 'following_id', 'follower_id')
                    ->withTimestamps();
    }

    // Người mà user này đang theo dõi (following)
public function following()
    {
        return $this->belongsToMany(User::class, 'follows', 'follower_id', 'following_id')
                    ->withTimestamps();
    }

    protected $fillable = [
        'name',
        'email',
        'password',
        'language',
        'pet_name',
        'avatar',   
        'phone', 
    ];

    protected $hidden = [
        'password',
        'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];
    
}