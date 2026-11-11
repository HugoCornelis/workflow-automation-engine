# A deliberately broken command file.  Its Python is syntactically valid (so it
# passes the engine's plugin syntax check) but it raises at load time, which
# makes the generated wrapper fail when the engine does() it.  This exercises the
# config-loader error path in _init_do_eval_perl_file: the failure must be
# reported as an invalid configuration file (syntax error), NOT misreported via a
# stale errno as "no configuration file ... (No such file or directory)".

raise RuntimeError("deliberate failure in broken command file")
