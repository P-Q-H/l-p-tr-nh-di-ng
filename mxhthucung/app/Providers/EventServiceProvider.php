<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;

class EventServiceProvider extends ServiceProvider
{
    protected $listen = [
        // Ví dụ:
        // 'App\Events\UserRegistered' => [
        //     'App\Listeners\SendWelcomeEmail',
        // ],
    ];

    public function boot()
    {
        parent::boot();

        // Bạn có thể đăng ký thêm sự kiện ở đây nếu cần
    }
}