=begin
 Event Extender 5
 Description Module
 ===============================================================================
 http://www.biloucorp.com
 ===============================================================================
=end

# ===============================================================================
# Importation des catégories
# ===============================================================================
register_category(:standard, "Commandes 'Standard'",
  "Collection de commandes classiques, relatives aux cartes et divers."
)
register_category(:events, "Commandes Evènement",
  "Collection de commandes relative à la manipulation/gestion des évènements."
)
register_category(:titlescreen, "Commandes Ecran titre",
  "Collection de commandes relative au Tueur d'écran titre"
)
register_category(:generator, "Commandes de génération",
  "Collection de commandes qui génères des éléments."
)
register_category(:keyboard, "Commandes Clavier",
  "Collection de commandes relative à la manipulation du clavier."
)
register_category(:mouse, "Commandes Souris",
  "Collection de commandes relative à la manipulation de la souris."
)
register_category(:clipboard, "Commandes Presse-papier",
  "Collection de commandes relative à la manipulation du clavier."
)
register_category(:xbox360, "Commandes XBOX360 Joypad",
  "Collection de commandes relative à la manipulation de la manette XBOX 360."
)
register_category(:none, "Non triées",
  "Collection de commandes non triées."
)
# ===============================================================================
# Importation des commandes
# ===============================================================================
import_command(
  :random, :standard, 
  "Renvoie un nombre aléatoire compris entre Minimum et Maximum",
  [
    {name:"Minimum", type: :int, default: 0}, 
    {name:"Maximum", type: :int}
  ], :int
)
import_command(:map_id,   :standard,  "Renvoi l'ID de la map en cours",   :int)
import_command(:map_name, :standard,  "Renvoi le nom de la map en cours", :string)
import_command(
  :event_id_at, :standard, 
  "Renvoie l'ID de l'évènement positionné par X et Y (-1 si aucun évènement, 0 si héros)",
  [
    {name:"X", type: :int}, 
    {name:"Y", type: :int}
  ], :int
)
import_command(
  :terrain_tag, :standard, 
  "Renvoie le tag de terrain de la case X Y",
  [
    {name:"X", type: :int}, 
    {name:"Y", type: :int}
  ], :int
)
import_command(
  :tile_id, :standard, 
  "Renvoie l'ID du tile de la case X Y, en fonction de la couche",
  [
    {name:"X", type: :int}, 
    {name:"Y", type: :int},
    {name:"Couche", type: :int}
  ], :int
)
import_command(
  :region_id, :standard, 
  "Renvoie l'ID de la région de la case X Y",
  [
    {name:"X", type: :int}, 
    {name:"Y", type: :int}
  ], :int
)
import_command(
  :square_passable?, :standard, 
  "Renvoie true si la case XY est passable dans une certaine direction",
  [
    {name:"X", type: :int}, 
    {name:"Y", type: :int},
    {name:"Direction", type: :int},
  ], :bool
)
import_command(
  :percent, :standard, 
  "Renvoie le pourcentage de valeur par rapport à Maximum",
  [
    {name:"valeur", type: :int}, 
    {name:"Maximum", type: :int}
  ], :int
)
import_command(
  :apply_percent, :standard, 
  "Applique un pourcentage à une valeur",
  [
    {name:"Pourcentage", type: :int}, 
    {name:"Valeur", type: :int}
  ], :int
)
import_command(
  :color, :generator, 
  "Renvoie une couleur (RVBA)",
  [
    {name:"Rouge", type: :int}, 
    {name:"Vert", type: :int}, 
    {name:"Bleu", type: :int}, 
    {name:"Alpha", type: :int, default: 255}
  ], :color
)
import_command(
  :tone, :generator, 
  "Renvoie une teinte (RVBA)",
  [
    {name:"Rouge", type: :int}, 
    {name:"Vert", type: :int}, 
    {name:"Bleu", type: :int}, 
    {name:"Alpha", type: :int, default: 255}
  ], :tone
)
import_command(
  :include_page, :standard, 
  "Inclus la page (Page ID) d'un évènement ID (situé sur MAP ID) dans un autre évènement",
  [
    {name:"Map ID", type: :int}, 
    {name:"Event ID", type: :int},
    {name:"Page ID", type: :int}
  ], :void
)
import_command(:windows_username, :standard,  "Renvoi le nom d'utilisateur Windows du joueur (ici : #{USERNAME})", :string)
import_command(
  :key_press?, :keyboard, 
  "Renvoie true si la touche passée en argument est appuyée",
  [
    {name:"Touche", type: :key}
  ], :bool
)
import_command(
  :key_trigger?, :keyboard, 
  "Renvoie true si la touche passée en argument vient d'être appuyée",
  [
    {name:"Touche", type: :key}
  ], :bool
)
import_command(
  :key_release?, :keyboard, 
  "Renvoie true si la touche passée en argument vient d'être relachée",
  [
    {name:"Touche", type: :key}
  ], :bool
)
import_command(
  :key_repeat?, :keyboard, 
  "Renvoie true si la touche passée en argument est appuyée successivement",
  [
    {name:"Touche", type: :key}
  ], :bool
)
import_command(
  :ctrl?, :keyboard, 
  "Renvoie true si la combinaison control + une touche est enfoncée",
  [
    {name:"Touche", type: :key}
  ], :bool
)
import_command(
  :keyboard_all?, :keyboard, 
  "Renvoie true si toutes les touches passées sont pressées selon la méthode définie",
  [
    {name: "Methode", type: [:enum, :press?, :trigger?, :repeat?, :release?]},
    {name:"Touche", type: [:list, :key]}
  ], :bool
)
import_command(
  :keyboard_any?, :keyboard, 
  "Renvoie true si une des touches passées est pressée selon la méthode définie",
  [
    {name: "Methode", type: [:enum, :press?, :trigger?, :repeat?, :release?]},
    {name:"Touche", type: [:list, :key]}
  ], :bool
)
import_command(
  :caps_lock?, :keyboard, 
  "Renvoie true si le clavier est en VERR MAJ",
  :bool
)
import_command(
  :num_lock?, :keyboard, 
  "Renvoie true si le clavier est en NUM LOCK",
  :bool
)
import_command(
  :scroll_lock?, :keyboard, 
  "Renvoie true si le clavier est en SCROLL LOCK",
  :bool
)
import_command(
  :maj?, :keyboard, 
  "Renvoie true si le clavier est en mode Majuscule (si une touche Maj est enfoncé ou si VERR Maj est activé)",
  :bool
)
import_command(
  :altr_g?, :keyboard, 
  "Renvoie true si la combinaison Alt+GR est enfoncée",
  :bool
)
import_command(
  :keyboard_num, :keyboard, 
  "Renvoie le numero appuyé sur le clavier (à l'instant de l'appel de la commande)",
  :int
)
import_command(
  :keyboard_letter, :keyboard, 
  "Renvoie le caractère appuyé sur la clavier (à l'instant de l'appel de la commande)",
  :string
)
import_command(
  :key_time, :keyboard, 
  "Renvoie le nombre de frame qu'est pressé une touche",
  [
    {name:"Touche", type: :key}
  ],
  :int
)
import_command(
  :key_current, :keyboard, 
  "Renvoie la touche courante, pressée selon la méthode passée en argument",
  [
    {name:"Methode", type: [:enum, :press?, :trigger?, :repeat?, :release?]}
  ],
  :int
)
import_command(
  :mouse_press?, :mouse, 
  "Renvoie true si la touche passée en argument est appuyée",
  [
    {name:"Touche", type: :mouse}
  ], :bool
)
import_command(
  :mouse_trigger?, :mouse, 
  "Renvoie true si la touche passée en argument vient d'être appuyée",
  [
    {name:"Touche", type: :mouse}
  ], :bool
)
import_command(
  :mouse_release?, :mouse, 
  "Renvoie true si la touche passée en argument vient d'être relachée",
  [
    {name:"Touche", type: :mouse}
  ], :bool
)
import_command(
  :mouse_repeat?, :mouse, 
  "Renvoie true si la touche passée en argument est appuyée successivement",
  [
    {name:"Touche", type: :key}
  ], :bool
)
import_command(
  :mouse_all?, :mouse, 
  "Renvoie true si toutes les touches passées sont pressées selon la méthode définie",
  [
    {name: "Methode", type: [:enum, :press?, :trigger?, :repeat?, :release?]},
    {name:"Touche", type: [:list, :mouse]}
  ], :bool
)
import_command(
  :mouse_any?, :mouse, 
  "Renvoie true si une des touches passées est pressée selon la méthode définie",
  [
    {name: "Methode", type: [:enum, :press?, :trigger?, :repeat?, :release?]},
    {name:"Touche", type: [:list, :mouse]}
  ], :bool
)
import_command(
  :mouse_x, :mouse, 
  "Renvoi la position en X de la souris",
  :int
)
import_command(
  :mouse_y, :mouse, 
  "Renvoi la position en Y de la souris",
  :int
)
import_command(
  :mouse_x_square, :mouse, 
  "Renvoi la position en X de la case ou se trouve la souris",
  :int
)
import_command(
  :mouse_y_square, :mouse, 
  "Renvoi la position en Y de la case ou se trouve la souris",
  :int
)
import_command(
  :mouse_rect, :mouse, 
  "Renvoi une zone définie par le rectangle de sélection de la souris",
  :int
)
import_command(
  :mouse_last_rect, :mouse, 
  "Renvoi la dernière zone définie par le rectangle de sélection de la souris",
  :int
)
import_command(
  :click_time, :mouse, 
  "Renvoie le nombre de frame qu'est pressé une touche",
  [
    {name:"Touche", type: :mouse}
  ],
  :int
)
import_command(
  :mouse_current, :mouse, 
  "Renvoie la touche courante, pressée selon la méthode passée en argument",
  [
    {name:"Methode", type: [:enum, :press?, :trigger?, :repeat?, :release?]}
  ],
  :int
)
import_command(
  :clipboard_get_text, :clipboard, 
  "Renvoie le texte du presse-papier",
  :string
)
import_command(
  :clipboard_push_text, :clipboard, 
  "Place du texte dans le presse-papier",
  [
    {name:"Texte", type: :string}
  ],
  :void
)
import_command(
  :pad360_plugged?, :xbox360, 
  "Renvoi true si une manette est branchée dans un port (référencé par un chiffre)",
  [
    {name:"Port", type: :int}
  ],
  :bool
)
import_command(
  :pad360_stop_vibration, :xbox360, 
  "Arrête de faire vibrer le moteur gauche et droit d'une manette (définie par son port)",
  [
    {name:"Port", type: :int}
  ],
  :void
)
import_command(
  :pad360_stop_vibration_left, :xbox360, 
  "Arrête de faire vibrer le moteur gauche d'une manette (définie par son port)",
  [
    {name:"Port", type: :int}
  ],
  :void
)
import_command(
  :pad360_stop_vibration_right, :xbox360, 
  "Arrête de faire vibrer le moteur droit d'une manette (définie par son port)",
  [
    {name:"Port", type: :int}
  ],
  :void
)
import_command(
  :pad360_vibrate, :xbox360, 
  "Fait vibrer une manette référencée par son port",
  [
    {name:"Port", type: :int},
    {name: "Force gauche", type: [:range, 0, 100]},
    {name: "Force droite", type: [:range, 0, 100]}
  ],
  :void
)
import_command(
  :pad360_vibrate_left, :xbox360, 
  "Fait vibrer le moteur gauche d'une manette référencée par son port",
  [
    {name:"Port", type: :int},
    {name: "Force gauche", type: [:range, 0, 100]},
  ],
  :void
)
import_command(
  :pad360_vibrate_right, :xbox360, 
  "Fait vibrer le moteur droit d'une manette référencée par son port",
  [
    {name:"Port", type: :int},
    {name: "Force droite", type: [:range, 0, 100]},
  ],
  :void
)
import_command(
  :mouse_hover_event?, :events, 
  "Renvoi true si la souris survol un évènement au moment de l'appel de la commande",
  [
    {name:"event ID", type: :int}
  ],
  :bool
)
import_command(
  :mouse_click_event?, :events, 
  "Renvoi true si la souris click sur un évènement au moment de l'appel de la commande",
  [
    {name:"event ID", type: :int},
    {name:"Touche", type: :mouse}
  ],
  :bool
)
import_command(
  :mouse_trigger_event?, :events, 
  "Renvoi true si la souris vient de clicker sur un évènement au moment de l'appel de la commande",
  [
    {name:"event ID", type: :int},
    {name:"Touche", type: :mouse}
  ],
  :bool
)
import_command(
  :mouse_release_event?, :events, 
  "Renvoi true si la souris vient d'être relachée sur un évènement au moment de l'appel de la commande",
  [
    {name:"event ID", type: :int},
    {name:"Touche", type: :mouse}
  ],
  :bool
)
import_command(
  :mouse_repeat_event?, :events, 
  "Renvoi true si la souris click successivement sur un évènement au moment de l'appel de la commande",
  [
    {name:"event ID", type: :int},
    {name:"Touche", type: :mouse}
  ],
  :bool
)
import_command(:start_new_game,   :titlescreen,  "Démarre une nouvelle partie",   :void)
import_command(:goto_title_screen,   :titlescreen,  "Renvoi à l'écran titre",   :void)
import_command(:goto_load_screen,   :titlescreen,  "Renvoi à l'écran de chargement de partie",   :void)