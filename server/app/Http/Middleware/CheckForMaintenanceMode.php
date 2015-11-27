<?php namespace App\Http\Middleware;

use Closure;
use Illuminate\Contracts\Routing\Middleware;
use Illuminate\Contracts\Foundation\Application;
use Illuminate\Http\Request;

class CheckForMaintenanceMode implements Middleware {
    
    protected $request;
    protected $app;

    public function __construct(Application $app, Request $request)
    {
        $this->app = $app;
        $this->request = $request;
    }

    public function handle($request, Closure $next)
    {
        if ($this->app->isDownForMaintenance() && 
            !in_array($this->request->getClientIp(), ['86.10.190.248', '86.4.7.24']))
        {
            return response('Be right back!', 503);
        }

        return $next($request);
    }

}