#ifndef THREADUTILS_H
#define THREADUTILS_H
#define _GNU_SOURCE
#include <sched.h>
#include <unistd.h>
#include <QThread>
#include <QDebug>

class ThreadUtils{
public:
    static int stick_this_thread_to_core(int core_id) {
        #if !(defined(Q_OS_LINUX) || defined(Q_OS_UNIX))
        qDebug()<<"needs linux threads in order to set affinity.";
        return -1;
        #endif
        int num_cores = sysconf(_SC_NPROCESSORS_ONLN);
        if (core_id < 0 || core_id >= num_cores)
            return EINVAL;
        cpu_set_t cpuset;
        CPU_ZERO(&cpuset);
        CPU_SET(core_id, &cpuset);
        pthread_t current_thread = pthread_self();
        return pthread_setaffinity_np(current_thread, sizeof(cpu_set_t), &cpuset);
    }
    static int pin_to_core(int core_id, pthread_t ui_thread) {
        #if !(defined(Q_OS_LINUX) || defined(Q_OS_UNIX))
        qDebug()<<"needs linux threads in order to set affinity.";
        return -1;
        #endif
        int num_cores = sysconf(_SC_NPROCESSORS_ONLN);
        if (core_id < 0 || core_id >= num_cores)
            return EINVAL;
        cpu_set_t cpuset;
        CPU_ZERO(&cpuset);
        CPU_SET(core_id, &cpuset);
        return pthread_setaffinity_np(ui_thread, sizeof(cpu_set_t), &cpuset);
    }
    static int assign_to_n_cores(int core_amount, pthread_t main_thread) {
        #if !(defined(Q_OS_LINUX) || defined(Q_OS_UNIX))
        qDebug()<<"needs linux threads in order to set affinity.";
        return -1;
        #endif
        int num_cores = sysconf(_SC_NPROCESSORS_ONLN);
        if (core_amount < 1 || core_amount >= num_cores)
            return EINVAL;
        cpu_set_t cpuset;
        CPU_ZERO(&cpuset);
        for (int j = 0; j < core_amount; j++){
            CPU_SET(j, &cpuset);
        }
        return pthread_setaffinity_np(main_thread, sizeof(cpu_set_t), &cpuset);
    }

};


#endif // THREADUTILS_H
