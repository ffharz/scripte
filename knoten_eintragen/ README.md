Knoten eintragen 
================

Stand: 30.05.2016

add_knoten.sh - hinzufügen neuer Knoten mit Commit als Parameter
del_Knoten.sh - löschen alter Knoten ohne Parameter

---

als erste muss man die /.git/config anpassen und ein zweites Repo eintragen 

das script ruft man mit den Commit als Parameter auf 

./add_knoten.sh Commit 

danach wird das repo mit dem remote namen orion und dann das repo mit dem remote Namen ff-harz gepusht.

----

so würde die /.git/config aussehen

<pre><code>
[core]
        repositoryformatversion = 0
        filemode = true
        logallrefupdates = true
[remote "origin"]
        url = https://benutzer:password@gitlab.com/ff-harz/fastd-peers.git
        fetch = +refs/heads/*:refs/remotes/origin/*
[remote "ff-harz"]
        url = http://benutzer:password@git.harz.freifunk.net/ff-harz/fastd-pe$
        fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
        remote = origin
        merge = refs/heads/master
</code></pre>
