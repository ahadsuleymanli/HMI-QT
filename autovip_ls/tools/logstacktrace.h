#ifndef DUMPSTACKTRACE_H
#define DUMPSTACKTRACE_H
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <QString>
// The code below was obtained from:
// http://stackoverflow.com/questions/77005/how-to-generate-a-stacktrace-when-my-gcc-c-app-crashes/1925461#1925461
#ifndef _GNU_SOURCE
#define _GNU_SOURCE
#endif
#ifndef __USE_GNU
#define __USE_GNU
#endif

#include <QDir>
#include <execinfo.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ucontext.h>
#include <unistd.h>
#include <QDebug>
#include <QDateTime>

/* This structure mirrors the one found in /usr/include/asm/ucontext.h */
typedef struct _sig_ucontext {
    unsigned long     uc_flags;
    struct ucontext   *uc_link;
    stack_t           uc_stack;
    struct sigcontext uc_mcontext;
    sigset_t          uc_sigmask;
} sig_ucontext_t;

void crit_err_hdlr(int sig_num, siginfo_t * info, void * ucontext) {
    void *             array[50];
    void *             caller_address;
    char **            messages;
    int                size, i;
    sig_ucontext_t *   uc;

    uc = (sig_ucontext_t *)ucontext;

    /* Get the address at the time the signal was raised */
    #if defined(__i386__) // gcc specific
        caller_address = (void *) uc->uc_mcontext.eip; // EIP: x86 specific
    #elif defined(__x86_64__) // gcc specific
        caller_address = (void *) uc->uc_mcontext.rip; // RIP: x86_64 specific
    #elif defined(__arm__) // gcc specific
        caller_address = (void *) uc->uc_mcontext.arm_pc; // arm32
    #elif defined(__aarch64__) // gcc specific
        caller_address = (void *) uc->uc_mcontext.pc; //arm 64
    #else
    #error Unsupported architecture. // TODO: Add support for other arch.
    #endif

    FILE * backtraceFile;
    if (!QDir("./stacktrace").exists())
        QDir().mkdir("./stacktrace");
    QString backtraceFilePath = "./stacktrace/stacktrace.txt";
    backtraceFile = fopen(backtraceFilePath.toUtf8().data(),"a");

    fprintf(backtraceFile,"logged at %s\n", QDateTime::currentDateTime().toString("dd.MM.yyyy hh:mm:ss.z").toStdString().c_str());

    if (sig_num == SIGSEGV)
        fprintf(backtraceFile, "signal %d (%s), address is %p from %p\n",sig_num, strsignal(sig_num), info->si_addr,(void *)caller_address);
    else
        fprintf(backtraceFile, "signal %d (%s)\n",sig_num, strsignal(sig_num));

    size = backtrace(array, 50);
    /* overwrite sigaction with caller's address */
    array[1] = caller_address;
    messages = backtrace_symbols(array, size);
    /* skip first stack frame (points here) */
    for (i = 1; i < size && messages != nullptr; ++i) {
        fprintf(backtraceFile, "[bt]: (%d) %s\n", i, messages[i]);
    }
    fprintf(backtraceFile, "\n\n");
    fclose(backtraceFile);
    free(messages);

    exit(EXIT_FAILURE);
}

void installSignal(int __sig) {
    struct sigaction sigact;
    sigact.sa_sigaction = crit_err_hdlr;
    sigact.sa_flags = SA_RESTART | SA_SIGINFO;
    if (sigaction(__sig, &sigact, (struct sigaction *)NULL) != 0) {
        fprintf(stderr, "error setting signal handler for %d (%s)\n",__sig, strsignal(__sig));
        exit(EXIT_FAILURE);
    }
}

void enableStackTraceDump(){
    qDebug()<<"enabling stack backtracing";
    installSignal(SIGINT);
    installSignal(SIGQUIT);
    installSignal(SIGTSTP);

    installSignal(SIGSEGV);
    installSignal(SIGBUS);
    installSignal(SIGFPE);
    installSignal(SIGILL);
    installSignal(SIGABRT);
    installSignal(SIGTRAP);
    installSignal(SIGPIPE);
    installSignal(SIGTERM);
    installSignal(SIGTTIN);
    installSignal(SIGTTOU);
    installSignal(SIGSYS);
    installSignal(SIGXCPU);
    installSignal(SIGXFSZ);
}

#endif // DUMPSTACKTRACE_H
