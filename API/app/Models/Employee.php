<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Employee extends Model
{
    use HasFactory;

    protected $table = 'employees';

    protected $fillable = [
        'id',
        'user_id',
        'position_id',
        'department_id',
        'first_name',
        'last_name',
        'gender',
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

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function position()
    {
        return $this->belongsTo(Position::class);
    }

    public function department()
    {
        return $this->belongsTo(Department::class, 'department_id');
    }

    public function absensi()
    {
        return $this->hasMany(Absensi::class);
    }

    public function salaryReports()
    {
        return $this->hasMany(SalaryReport::class);
    }
}