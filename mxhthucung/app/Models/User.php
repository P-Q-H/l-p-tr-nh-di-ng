<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Passport\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens,  Notifiable;
public function likedPosts()
{
    return $this->belongsToMany(Post::class, 'likes', 'user_id', 'post_id');
}

    protected $fillable = [
        'name',
        'email',
        'password',
        'language',
        'pet_name',
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