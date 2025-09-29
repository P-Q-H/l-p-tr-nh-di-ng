<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    public function user()
{
    return $this->belongsTo(\App\Models\User::class);
}
public function likes()
{
    return $this->belongsToMany(User::class, 'likes', 'post_id', 'user_id');
}

    
    protected $fillable = [
    'user_id',
    'pet_name',
    'breed',
    'description',
    'image',
    'pet_type',
];


}