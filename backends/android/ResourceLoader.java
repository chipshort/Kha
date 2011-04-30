package de.hsharz.game;

import java.io.BufferedInputStream;
import java.io.DataInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.BitmapFactory;
import de.hsharz.game.engine.Image;
import de.hsharz.game.engine.Loader;
import de.hsharz.game.engine.Music;
import de.hsharz.game.engine.Sound;

public class ResourceLoader extends Loader {
	private AssetManager assets;
	private Context context;
	
	public ResourceLoader(Context context) {
		this.context = context;
		this.assets = context.getAssets();
	}
	
	@Override
	public Image loadImage(String filename) {
		try {
			return new BitmapImage(BitmapFactory.decodeStream(assets.open(filename + ".png")));
		}
		catch (IOException e) {
			return null;
		}
	}

	@Override
	public Sound loadSound(String filename) {
		try {
			return new AndroidSound(assets.openFd(filename + ".wav"));
		} catch (IOException e) {
			return null;
		}
	}

	@Override
	public Music loadMusic(String filename) {
		return new AndroidMusic(context);
	}

	@Override
	public int[][] loadLevel() {
		int[][] map;
		try {
			DataInputStream stream = new DataInputStream(new BufferedInputStream(assets.open("level.map")));
			int levelWidth = stream.readInt();
			int levelHeight = stream.readInt();
			map = new int[levelWidth][levelHeight];
			for (int x = 0; x < levelWidth; ++x) for (int y = 0; y < levelHeight; ++y) {
				map[x][y] = stream.readInt();
			}
			return map;
		}
		catch (FileNotFoundException e) {
			return null;
		}
		catch (IOException e) {
			return null;
		}
	}
}