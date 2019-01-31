# Modeling4Cloud

Progetto per il monitoraggio attivo delle performance sui fornitori di servizi cloud, tramite una rete distribuita di macchine virtuali ospitate sui datacenter da monitorare.

# Installazione cluster mongodb
L’installazione del cluster mongo è stata automatizzata, per installare due shard contenenti i dati su due vm e un config server con un mongos router su una terza macchina. Questa procedura può essere richiamata tramite lo script utils/instructions/clusterSetup.sh, lo script si collega alle macchine di destinazione tramite ssh, quindi sarà necessario aggiornare tutti gli ip (e i relativi file di chiave privata) nel caso la infrastruttura sulla quale viene effettuata la distribuzione sia differente da quella sulla quale è stato effettuato il test, i compiti di installazione dei vari shard, config e mongos router sono stati suddivisi in vari script all’interno della cartella utils/instructions/mongo, anche questi file andranno aggiornati in base alla infrastruttura utilizzata.

# Installazione backend e frontend
Sul server è necessario avere preinstallato git e npm per poterli usare da riga di comando.

L’installazione e l’avvio del server (backend e frontend) è stata automatizzata ed è avviabile tramite lo script in utils/instructions/startBackend.sh.

Lo script si collega alla macchina server tramite ssh (vedi ip nello script) e scarica la versione più aggiornata dell’applicazione dalla repo github nella cartella ~/Modeling4Cloud, a questo punto dopo aver installato tutti i pacchetti NPM necessari avvia backend e frontend.

# Distribuzione dei probe
L’installazione dei probe viene avviata tramite lo script deploy.sh, dove bisogna attivare(rimuovendo i commenti) le righe relative alle parti di test che si desiderano attivare, in base alla tipologia di test (Hping, Iperf) ed in base al provider sul quale si desidera eseguirle (AWS,GCP,AZURE,IBM ecc..). In questo file vanno impostati gli indirizzi degli endpoint API del backend Node da utilizzare per caricare i risultati per i test di ping e i test di banda.

Per ogni provider bisogna configurare il file di impostazioni relativo ( AWS.sh, GCP.sh ecc...). In questo file le informazioni sono divise in tre gruppi:
-	Impostazioni dei test diretti, tra due macchine specifiche tramite hping (avviati tramite lo script utils/instructions/hping/setupHping.sh)
-	Impostazioni dei test diretti, tra due macchine specifiche tramite iperf (avviati tramite lo script utils/instructions/hping/setupIperf.sh)
-	Impostazioni dei test tra più regioni, che possono essere avviati tramite gli script setupCrossHping.sh e setupCrossIperf.sh per i test tra regioni diverse, oppure tramite setupSameHping.sh e setupSameIperf.sh per i test all’interno della stessa regione

In ogni caso per ogni macchina bisogna fornire la posizione del file contenente la chiave privata necessaria per collegarsi in ssh alla macchina, il suo ip pubblico e la regione geografica sulla quale è ospitata (consultare i commenti all’interno del file di configurazione per indicazioni più specifiche).
