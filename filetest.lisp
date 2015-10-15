(with-open-file (str *STANDARD-INPUT*
                     :direction :INPUT
                     ;:if-exists <if-exists>
                     :if-does-not-exist :ERROR)
  	(loop for line = (read-line str nil)
  		while line do (line)
	)
)