<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Follow extends Model
{
    protected $fillable = [
        'follower_id',
        'following_id',
    ];

    // Người theo dõi
    public function follower()
    {
        return $this->belongsTo(User::class, 'follower_id');
    }

    // Người được theo dõi
    public function following()
    {
        return $this->belongsTo(User::class, 'following_id');
    }
}