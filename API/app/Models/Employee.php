<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Employee extends Model
{
    use HasFactory;

    protected $table = 'employees';

    protected $fillable = [
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
    // RELATIONS
    // ============================

    // Employee → User
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Employee → Position
    public function position()
    {
        return $this->belongsTo(Position::class);
    }

    // Employee → Department
    public function department()
    {
        return $this->belongsTo(Department::class, 'department_id');
    }

    // Employee → Absensi
    public function absensi()
    {
        return $this->hasMany(Absensi::class);
    }

    // Employee → Salary Reports
    public function salaryReports()
    {
        return $this->hasMany(SalaryReport::class);
    }
}
