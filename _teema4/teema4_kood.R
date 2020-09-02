# --- Rakendustarkvara R
# --- IV teema ----



# --- 1. Toimingud andmestikuga - jätk ----

# Andmestik
mk <- read.table("https://github.com/Rkursus/tykliinikum/raw/master/data/maakonnad.txt", sep = " ", header = TRUE)



# --- 1.1 Andmestike täiendamine ja ühendamine ----

# Teeme kaks uut tunnust

suurus <- cut(mk$pop_estimate, c(0, 1000, 10000, 1000000, Inf),
              labels = c("mikro", "väike", "keskmine", "suur"), include.lowest = T)
sooylekaal <- ifelse(mk$fem > 50, "F", "M")

# Lisame need vektorid andmestiku lõppu veergudeks:
mk <- cbind(mk, suurus, sooylekaal)
# või
lisatabel<- data.frame(suurus, sooylekaal)
mk <- cbind(mk, lisatabel)

# ridade lisamine, praegu tekitame sellega dubleeritud vaatlusi!
lisa <- rep(seq(1, nrow(mk), by = 60),c(1:3, 1:3, 1, 1))
mktopelt <- rbind(mk, mk[lisa, ])


# Käsu 'merge()' testimiseks andmed
isikud <- data.frame(nimi = c("Peeter", "Mari", "Tiina", "Laine"),
                     sugu = c("M", "N", "N", "N"), vanus = c(30, 22, 25, 20))
tulemused <- data.frame(nimi = c("Mari", "Peeter", "Tiina", "Peeter", "Toomas"),
                        tulemus = c(30.1, 22.5, 18.4, 25.3, 20.4),
                        voistlus = c("jooks1", "jooks1", "jooks2", "jooks2", "jooks2"))
isikud
tulemused

# Nime kaudu andmestike liitmine
(kokku <- merge(isikud, tulemused, by = "nimi", all = TRUE))

#---- ÜL 1.1.1 ----
# 1 
# Kuidas peaks merge käsu kirja panema, kui isikud ja tulemused andmestikes on võtmetunnusel erinev nimi?
?merge


# 2
# Proovi, mis muutub merge käsu tulemuses, kui kasutada all = TRUE argumendi asemel all.x = TRUE või all.y = TRUE
(kokku_x <- merge(isikud, tulemused, by = "nimi", all.x = TRUE))
(kokku_y <- merge(isikud, tulemused, by = "nimi", all.y = TRUE))

# Mis oli erinev?


# --- 2. Andmetöötlus paketiga dplyr ----

#install.packages(dplyr) # vajadusel installeerida pakett
library(dplyr)

#--- 2.1 Paketi dplyr käskude kasutamine ----

# Andmestik
mass <- read.table("https://github.com/Rkursus/sygis2019/raw/master/data/mass.txt", sep = "\t", header = T)


# Käsk 'mutate()': arvutame kaks uut tunnust, kustutame ühe vana
mass1 <- mutate(mass,
                kuus = WAGP/12,
                kuus_euro = kuus * 0.8,
                MIG = NULL)

# Käsk 'filter()': rakendame filtrit (ekraanile paari esimese veeru väärtused neil vaatlustel)
filter(mass, AGEP > 70, WAGP > 100000)[,1:3]

# Käsk 'select()': rakendame filtrit ja selekteerime tunnuseid
select(filter(mass, AGEP > 70, WAGP > 100000), contains("G"))

# Käsud 'summarise()' ja 'group_by()':
summarise(group_by(mass, CIT),
          keskpalk = mean(WAGP, na.rm = T),
          n = n(),
          notNA = sum(!is.na(WAGP)))


# Käsk 'arrange()': andmestike sorteerimine
osa <- filter(select(mass, id, SEX, AGEP, WKHP, WAGP), WAGP > 300000, AGEP < 55)
arrange(osa, SEX, desc(AGEP), WKHP)


# Toruoperaator (piping) '%>%': 
mass %>%
  group_by(SEX, MAR) %>%
  summarise(keskpalk = mean(WAGP, na.rm = T), n = n()) %>%
  head()

# versus samad operatsioonid ilma toru operaatorita
head(summarise(group_by(mass, SEX, MAR), keskpalk = mean(WAGP, na.rm = T), n = n()))

# Kumba varianti on lihtsam lugeda?



# --- ÜL 2.1.1 ----

# 1

# variant A, aheldamist kasutades
mass %>% 
  filter(______) %>% 
  mutate(vanusgrupp = ______) %>%
  group_by(______) %>%
  summarise(kesk = ______, 
            max = ______,
            "gruppide maht" = ______,
            "pole NA" = ______)


# variant B, aheldamiseta
tabel <- 
  summarise(group_by(mutate(filter(______,______), 
                            vanusgrupp = ______,
                            kesk = ______, 
                            max = ______,
                            "gruppide maht" = ______,
                            "pole NA" = ______)))

tabel

# Kumba varianti on lihtsam koostada? Kumba hiljem lugeda?




#--- 3. Pikk ja lai andmetabel ----

# --- 3.1 Pikk ja lai andmetabel. Pakett reshape2 ----

#install.packages("reshape2") # kui arvutis pole paketti reshape2, siis esmalt installida
library(reshape2)
vr <- data.frame(nimi = c("Mari", "Jaan", "Jyri"),
                 kaal = c(68, 65, 100),
                 pikkus = c(170, 180, 190),
                 sugu = c(2, 1, 1),
                 pulss0m = c(70, 80, 80),
                 pulss10m = c(130, 120, 190), pulss30m = c(150, 120, NA))
(m <- melt(vr, measure.vars = 5:7)) # välimised sulud tingivad ekraanile trükkimise


# Pikast formaadist laia teisendamine
dcast(m, formula = nimi ~ variable)

dcast(m, nimi + kaal ~ variable + sugu)

dcast(m, nimi ~ . , fun.aggregate = mean, na.rm = TRUE, value.var = "value")



# --- ÜL 3.1.1 ----

# 1 
link <- "https://github.com/Rkursus/tykliinikum/raw/master/data/"
valik <- read.table(paste0(link, "valik.txt"), sep = "\t", header = TRUE)
head(valik)


# laiale kujule: igale inimesele ritta ik, sugu , skp,  vanus , vr1 ja vr2
dcast(valik, ______)




# laiale kujule: igale inimesele ritta ik, sugu , skp,  vanus , CRV1 ja CRV2 ning vr1 ja vr2
# enne tuleks viia veel pikemalt kujule: mõlemad mõõtmistunnused ühte veergu

abi <- melt(valik, _______)
head(abi)

dcast(abi, _______)



# 2. igale inimesele keskmine VR ja CRV


