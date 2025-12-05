<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Employee extends Model
{
<<<<<<< HEAD
    protected $table = 'employees';

    protected $fillable = [
=======
    use HasFactory;

    protected $table = 'employees'; // sesuaikan kalau nama tabel berbeda

    protected $fillable = [
        'id',
>>>>>>> ba274c782e3c735394d2afcd153dc18227fbff87
        'user_id',
        'position_id',
        'department_id',
        'first_name',
        'last_name',
        'gender',
<<<<<<< HEAD
        'address'
    ];

=======
        'address',
    ];

    protected $casts = [
        'user_id' => 'integer',
        'position_id' => 'integer',
        'department_id' => 'integer',
    ];

    // ============================
    // RELASI
    // ============================

    // Employee -> User
>>>>>>> ba274c782e3c735394d2afcd153dc18227fbff87
    public function user()
    {
        return $this->belongsTo(User::class);
    }

<<<<<<< HEAD
=======
    // Employee -> Position
>>>>>>> ba274c782e3c735394d2afcd153dc18227fbff87
    public function position()
    {
        return $this->belongsTo(Position::class);
    }

<<<<<<< HEAD
=======
    // Employee -> Department
>>>>>>> ba274c782e3c735394d2afcd153dc18227fbff87
    public function department()
    {
        return $this->belongsTo(Department::class);
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> ba274c782e3c735394d2afcd153dc18227fbff87
